import Sound
import lean_certs.cert_37_104

open CertVerify

theorem H37_gt_104 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 37) (d := 104) (c := cert_37_104) (by native_decide)
