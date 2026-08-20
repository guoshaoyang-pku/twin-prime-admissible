import Sound
import lean_certs.cert_28_104

open CertVerify

theorem H28_gt_104 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 28) (d := 104) (c := cert_28_104) (by native_decide)
