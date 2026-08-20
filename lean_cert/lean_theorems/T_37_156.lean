import Sound
import lean_certs.cert_37_156

open CertVerify

theorem H37_gt_156 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 37) (d := 156) (c := cert_37_156) (by native_decide)
