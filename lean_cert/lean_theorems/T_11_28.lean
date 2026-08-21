import Sound
import lean_certs.cert_11_28

open CertVerify

theorem H11_gt_28 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 11) (d := 28) (c := cert_11_28) (by native_decide)
