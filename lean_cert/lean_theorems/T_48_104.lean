import Sound
import lean_certs.cert_48_104

open CertVerify

theorem H48_gt_104 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 48) (d := 104) (c := cert_48_104) (by native_decide)
