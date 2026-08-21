import Sound
import lean_certs.cert_40_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_80_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 40) (d := 80) (c := cert_40_80) (by decide)
