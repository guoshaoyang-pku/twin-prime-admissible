import Sound
import lean_certs.cert_39_178

open CertVerify

theorem H39_gt_178 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 39) (d := 178) (c := cert_39_178) (by native_decide)
