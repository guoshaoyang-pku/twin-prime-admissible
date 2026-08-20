import Sound
import lean_certs.cert_34_104

open CertVerify

theorem H34_gt_104 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 34) (d := 104) (c := cert_34_104) (by native_decide)
