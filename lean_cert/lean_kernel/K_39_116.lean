import Sound
import lean_certs.cert_39_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_116_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 39) (d := 116) (c := cert_39_116) (by decide)
