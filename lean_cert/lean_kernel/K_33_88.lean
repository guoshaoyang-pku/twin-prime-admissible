import Sound
import lean_certs.cert_33_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_88_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 33) (d := 88) (c := cert_33_88) (by decide)
