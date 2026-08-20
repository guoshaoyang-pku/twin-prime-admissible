import Sound
import lean_certs.cert_37_158

open CertVerify

theorem H37_gt_158 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 37) (d := 158) (c := cert_37_158) (by native_decide)
