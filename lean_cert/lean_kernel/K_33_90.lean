import Sound
import lean_certs.cert_33_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_90_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 33) (d := 90) (c := cert_33_90) (by decide)
