import Sound
import lean_certs.cert_25_104

open CertVerify

theorem H25_gt_104 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 25) (d := 104) (c := cert_25_104) (by native_decide)
