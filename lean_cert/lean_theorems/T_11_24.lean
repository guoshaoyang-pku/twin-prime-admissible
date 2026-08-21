import Sound
import lean_certs.cert_11_24

open CertVerify

theorem H11_gt_24 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 11) (d := 24) (c := cert_11_24) (by native_decide)
