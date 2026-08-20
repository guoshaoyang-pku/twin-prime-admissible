import Sound
import lean_certs.cert_49_104

open CertVerify

theorem H49_gt_104 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 49) (d := 104) (c := cert_49_104) (by native_decide)
