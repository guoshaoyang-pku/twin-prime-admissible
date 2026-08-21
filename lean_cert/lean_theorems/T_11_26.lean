import Sound
import lean_certs.cert_11_26

open CertVerify

theorem H11_gt_26 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 11) (d := 26) (c := cert_11_26) (by native_decide)
