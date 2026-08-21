import Sound
import lean_certs.cert_33_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_84_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 33) (d := 84) (c := cert_33_84) (by decide)
