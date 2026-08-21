import Sound
import lean_certs.cert_16_34

open CertVerify

theorem H16_gt_34 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 16) (d := 34) (c := cert_16_34) (by native_decide)
