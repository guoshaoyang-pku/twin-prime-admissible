import Sound
import lean_certs.cert_39_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_158_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 39) (d := 158) (c := cert_39_158) (by decide)
