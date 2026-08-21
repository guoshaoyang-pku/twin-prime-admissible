import Sound
import lean_certs.cert_16_38

open CertVerify

theorem H16_gt_38 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 16) (d := 38) (c := cert_16_38) (by native_decide)
