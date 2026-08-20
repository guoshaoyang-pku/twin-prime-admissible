import Sound
import lean_certs.cert_24_46

open CertVerify

theorem H24_gt_46 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 24) (d := 46) (c := cert_24_46) (by native_decide)
