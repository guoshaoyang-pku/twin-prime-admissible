import Sound
import lean_certs.cert_11_34

open CertVerify

theorem H11_gt_34 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 11) (d := 34) (c := cert_11_34) (by native_decide)
