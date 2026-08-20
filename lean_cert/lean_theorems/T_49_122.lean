import Sound
import lean_certs.cert_49_122

open CertVerify

theorem H49_gt_122 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 49) (d := 122) (c := cert_49_122) (by native_decide)
