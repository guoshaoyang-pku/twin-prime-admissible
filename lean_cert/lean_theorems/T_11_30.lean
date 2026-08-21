import Sound
import lean_certs.cert_11_30

open CertVerify

theorem H11_gt_30 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 11) (d := 30) (c := cert_11_30) (by native_decide)
