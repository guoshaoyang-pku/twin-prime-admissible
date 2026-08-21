import Sound
import lean_certs.cert_33_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_74_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 33) (d := 74) (c := cert_33_74) (by decide)
