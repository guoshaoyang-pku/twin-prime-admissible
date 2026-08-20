import Sound
import lean_certs.cert_21_48

open CertVerify

theorem H21_gt_48 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 21) (d := 48) (c := cert_21_48) (by native_decide)
