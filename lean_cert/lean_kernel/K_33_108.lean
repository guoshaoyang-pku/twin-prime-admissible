import Sound
import lean_certs.cert_33_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_108_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 33) (d := 108) (c := cert_33_108) (by decide)
