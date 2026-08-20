import Sound
import lean_certs.cert_41_162

open CertVerify

theorem H41_gt_162 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 41) (d := 162) (c := cert_41_162) (by native_decide)
