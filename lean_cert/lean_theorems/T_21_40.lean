import Sound
import lean_certs.cert_21_40

open CertVerify

theorem H21_gt_40 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 21) (d := 40) (c := cert_21_40) (by native_decide)
