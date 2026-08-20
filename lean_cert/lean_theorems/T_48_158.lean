import Sound
import lean_certs.cert_48_158

open CertVerify

theorem H48_gt_158 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 48) (d := 158) (c := cert_48_158) (by native_decide)
