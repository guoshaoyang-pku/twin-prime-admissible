import Sound
import lean_certs.cert_41_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_166_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 41) (d := 166) (c := cert_41_166) (by decide)
