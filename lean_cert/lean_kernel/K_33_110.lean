import Sound
import lean_certs.cert_33_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_110_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 33) (d := 110) (c := cert_33_110) (by decide)
