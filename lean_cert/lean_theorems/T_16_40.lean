import Sound
import lean_certs.cert_16_40

open CertVerify

theorem H16_gt_40 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 16) (d := 40) (c := cert_16_40) (by native_decide)
