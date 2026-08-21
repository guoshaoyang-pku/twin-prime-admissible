import Sound
import lean_certs.cert_39_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_138_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 39) (d := 138) (c := cert_39_138) (by decide)
