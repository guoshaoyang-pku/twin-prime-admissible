import Sound
import lean_certs.cert_48_122

open CertVerify

theorem H48_gt_122 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 48) (d := 122) (c := cert_48_122) (by native_decide)
