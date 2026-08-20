import Sound
import lean_certs.cert_38_104

open CertVerify

theorem H38_gt_104 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 38) (d := 104) (c := cert_38_104) (by native_decide)
