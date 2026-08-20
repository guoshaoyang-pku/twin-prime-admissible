import Sound
import lean_certs.cert_37_138

open CertVerify

theorem H37_gt_138 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 37) (d := 138) (c := cert_37_138) (by native_decide)
