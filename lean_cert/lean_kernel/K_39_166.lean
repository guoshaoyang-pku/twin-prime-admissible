import Sound
import lean_certs.cert_39_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_166_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 39) (d := 166) (c := cert_39_166) (by decide)
