import Sound
import lean_certs.cert_39_78

open CertVerify

theorem H39_gt_78 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 39) (d := 78) (c := cert_39_78) (by native_decide)
