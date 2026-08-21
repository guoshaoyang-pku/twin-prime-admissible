import Sound
import lean_certs.cert_13_24

open CertVerify

theorem H13_gt_24 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 13) (d := 24) (c := cert_13_24) (by native_decide)
