import Sound
import lean_certs.cert_28_62

open CertVerify

theorem H28_gt_62 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 28) (d := 62) (c := cert_28_62) (by native_decide)
