import Sound
import lean_certs.cert_30_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_80_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 30) (d := 80) (c := cert_30_80) (by decide)
