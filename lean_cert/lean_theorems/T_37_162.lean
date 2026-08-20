import Sound
import lean_certs.cert_37_162

open CertVerify

theorem H37_gt_162 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 37) (d := 162) (c := cert_37_162) (by native_decide)
