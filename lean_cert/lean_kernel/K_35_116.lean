import Sound
import lean_certs.cert_35_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_116_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 35) (d := 116) (c := cert_35_116) (by decide)
