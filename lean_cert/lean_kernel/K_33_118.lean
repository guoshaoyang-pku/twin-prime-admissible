import Sound
import lean_certs.cert_33_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_118_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 33) (d := 118) (c := cert_33_118) (by decide)
