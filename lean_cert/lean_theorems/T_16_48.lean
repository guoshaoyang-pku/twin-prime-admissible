import Sound
import lean_certs.cert_16_48

open CertVerify

theorem H16_gt_48 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 16) (d := 48) (c := cert_16_48) (by native_decide)
