import Sound
import lean_certs.cert_13_40

open CertVerify

theorem H13_gt_40 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 13) (d := 40) (c := cert_13_40) (by native_decide)
