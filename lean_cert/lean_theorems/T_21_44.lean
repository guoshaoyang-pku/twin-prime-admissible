import Sound
import lean_certs.cert_21_44

open CertVerify

theorem H21_gt_44 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 21) (d := 44) (c := cert_21_44) (by native_decide)
