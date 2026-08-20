import Sound
import lean_certs.cert_37_134

open CertVerify

theorem H37_gt_134 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 37) (d := 134) (c := cert_37_134) (by native_decide)
