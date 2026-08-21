import Sound
import lean_certs.cert_40_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_90_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 40) (d := 90) (c := cert_40_90) (by decide)
