import Sound
import lean_certs.cert_41_104

open CertVerify

theorem H41_gt_104 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 41) (d := 104) (c := cert_41_104) (by native_decide)
