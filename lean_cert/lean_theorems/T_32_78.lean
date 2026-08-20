import Sound
import lean_certs.cert_32_78

open CertVerify

theorem H32_gt_78 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 32) (d := 78) (c := cert_32_78) (by native_decide)
