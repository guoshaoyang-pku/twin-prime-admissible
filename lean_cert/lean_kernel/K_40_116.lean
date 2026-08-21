import Sound
import lean_certs.cert_40_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_116_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 40) (d := 116) (c := cert_40_116) (by decide)
