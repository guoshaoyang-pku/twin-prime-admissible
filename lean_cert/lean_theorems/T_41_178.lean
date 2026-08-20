import Sound
import lean_certs.cert_41_178

open CertVerify

theorem H41_gt_178 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 41) (d := 178) (c := cert_41_178) (by native_decide)
