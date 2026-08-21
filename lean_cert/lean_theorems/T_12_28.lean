import Sound
import lean_certs.cert_12_28

open CertVerify

theorem H12_gt_28 : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 12) (d := 28) (c := cert_12_28) (by native_decide)
