import Sound
import lean_certs.cert_26_104

open CertVerify

theorem H26_gt_104 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 26) (d := 104) (c := cert_26_104) (by native_decide)
